# Fact Seeker Log

Every task gets an entry. Read this log before starting a new investigation. Update it when done.

## Format
```
### [DATE] Task: <title>
- **Status**: done | in-progress | blocked
- **Finds**: key discoveries
- **Missed**: what was missed (fill in after coder/tester finds issues)
```

---

<!-- Entries below -->

## [2026-03-28] resume distill

### Training State

- **Status**: COMPLETED — the previous run finished all 15,000 steps naturally (not interrupted).
- **Run duration**: 249.8 minutes (~4.2 hours), started ~17:24, ended ~21:34 today.
- **Final step**: 15000/15000
- **Final loss**: loss=13.768 (hard=10.441, soft=15.194) at step 15000, lr=2.0e-05
- **Initial loss**: loss=15.466 (hard=12.510, soft=16.733) at step 10
- **Loss improvement**: ~1.7 composite loss units over the full run (from ~15.5 to ~13.8) — slow but steady descent, no divergence
- **LR at end**: 2.0e-05 (cosine decay from 2e-4, at floor ~0.1x)

### Eval Performance (inline, 5 problems every 500 steps)

- **Pass rate**: 0/5 (0%) at every eval checkpoint, steps 0 through 14500
- **Syntax rate**: Started 0/5, briefly reached 3/5 at step 500, then settled at 1/5 for all remaining evals
- **Conclusion**: Model is generating syntactically broken output. Zero functional correctness achieved in this run.

### Checkpoint Availability

- **final.pt**: EXISTS — `/home/kenpeter/work/mulmodel_ext/checkpoints/final.pt` (358 MB, written at step 15000)
- **step_15000.pt**: EXISTS
- **Step checkpoints saved**: step_200, 400, 600, 800, 1000, 1200, 1400, 1600, 1800, 2000, ..., 15000 (every 200 steps) — all present
- **Missing**: Optimizer state is NOT saved in checkpoints (only `step`, `model`, `config`). True resume would restart optimizer from scratch.

### Student Model Architecture

- **Params**: ~172.8M total (127.1M embedding, tied with lm_head; 45.6M in 12 transformer layers)
- **Layers**: 12 TransformerDecoderLayer with KDA (Kimi Delta Attention)
- **Hidden size**: 512
- **Attention heads**: 8 (GQA: 2 KV heads, 4 groups)
- **Head dim**: 64
- **FFN intermediate**: 2048 (SwiGLU-style: gate + up + down)
- **Vocab**: 248,320 (Qwen tokenizer)
- **Extras**: RMSNorm, gradient checkpointing enabled during training, attn_residual=True, sage_attention=False (disabled)
- **Weight tying**: lm_head tied to embed_tokens

### Teacher Model

- **Name**: `Jackrong/Qwen3.5-0.8B-Claude-4.6-Opus-Reasoning-Distilled`
- **Local path**: `~/.cache/huggingface/hub/models--Jackrong--Qwen3.5-0.8B-Claude-4.6-Opus-Reasoning-Distilled/snapshots/af2f37de41af0bdcaea5e3790ad323030ea4af07`
- **Loaded**: via `AutoModelForCausalLM.from_pretrained`, bfloat16, device_map="cuda", frozen
- **Init from teacher**: **0 tensors copied** — teacher shape mismatch with student (student is smaller: 512 vs teacher's larger dims). Student was trained from random init.

### What "resume distill" Means in This Context

The previous run **completed** (15000/15000 steps). "Resume distill" means **starting a new training run**, not literally continuing. Options:
1. **Fresh restart** from `final.pt` using `--resume` flag — loads model weights at step 15000, continues with new steps budget (capped by time budget logic). Optimizer state is lost (restarts cold).
2. **New run from scratch** — would re-init from teacher (still 0 tensors copied due to shape mismatch) and lose all learned weights.
3. **Extend existing** — the script's step counter would pick up from step 15000, but max_steps is time-capped and would be recalculated fresh.

Most likely intent: run `python scripts/train_kda_muon.py --resume` to load `final.pt` and train more steps with the cosine LR restarted.

### Key Risks / Blockers

1. **Zero pass rate throughout** — 0/5 syntax correctness at every inline eval. The model never learned to generate valid Python. Root causes:
   - Teacher init failed (0 tensors copied — size mismatch). Student trained from random weights.
   - max_length=1024 during training but generate uses no position limit, and there is no KV cache — generation degrades at longer sequences.
   - KDA attention may need debugging (delta attention mechanism with attn_residual).
2. **No optimizer state in checkpoints** — MuonClip momentum state is lost on resume; first ~50 steps will be cold-start.
3. **Time-budget cap**: `max_steps = min(15000, int(seconds_avail / 3.0))` — if run at wrong time of day the budget may be very small. Target is 06:00; run early in morning for maximum budget.
4. **Teacher init mismatch**: `init_from_teacher` copies 0 tensors because student dims (512 hidden, 64 head_dim) don't match teacher (Qwen3.5-0.8B has 1024 hidden, 64 head_dim per head). This is a design issue — student was always training from scratch.
5. **Loss plateau**: loss ~13.8 at step 15000 vs ~15.5 at step 10 — model is learning slowly. Hard loss ~10.4 (cross-entropy over vocab 248k, random baseline ~ln(248320)~12.4 — so slight improvement but still near random).
6. **Data**: Training on 2373 samples (90% of high_quality_leetcode/train.jsonl, held out every 10th). Small dataset may cause overfitting before meaningful generalization.

### Relevant Files

- `/home/kenpeter/work/mulmodel_ext/scripts/train_kda_muon.py` — training script
- `/home/kenpeter/work/mulmodel_ext/model/student.py` — student model
- `/home/kenpeter/work/mulmodel_ext/model/config.py` — StudentConfig defaults
- `/home/kenpeter/work/mulmodel_ext/model/attention.py` — KDA attention implementation
- `/home/kenpeter/work/mulmodel_ext/model/layer.py` — TransformerDecoderLayer
- `/home/kenpeter/work/mulmodel_ext/model/optimizer.py` — MuonClip optimizer
- `/home/kenpeter/work/mulmodel_ext/eval/leetcode_eval.py` — HuggingFace dataset eval (50 problems, sandbox execution)
- `/home/kenpeter/work/mulmodel_ext/eval/inline_eval.py` — inline eval used during training (5 problems)
- `/home/kenpeter/work/mulmodel_ext/eval_quick.py` — standalone eval script, auto-detects latest checkpoint
- `/home/kenpeter/work/mulmodel_ext/checkpoints/final.pt` — best available checkpoint (step 15000)
- `/home/kenpeter/work/mulmodel_ext/train.log` — full training log
