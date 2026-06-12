# DeHaze

A MATLAB implementation of **Single Image Haze Removal Using Dark Channel Prior** by He, Sun and Tang ([CVPR 2009](https://ieeexplore.ieee.org/document/5206515); [TPAMI 2011](https://ieeexplore.ieee.org/document/5567108)) — including the original paper's **soft-matting refinement** of the transmission map (Levin et al.'s matting Laplacian), rather than the faster guided-filter approximation.

## Pipeline

`HazeRemoval.m` runs the full algorithm on the bundled example (`haze.jpg`):

1. **Dark channel** (`DarkChannel.m`) — per-pixel minimum over RGB and a 15×15 neighborhood.
2. **Atmospheric light** — the brightest pixels among the top 0.1% of the dark channel.
3. **Transmission estimate** — `t = 1 − ω · dark(I/A)` with `ω = 0.95`.
4. **Soft matting** (`MattingLaplacian.m`) — builds Levin et al.'s closed-form matting Laplacian over 3×3 windows and refines the transmission by solving the sparse system `(L + λI) t = λ t̃` (λ = 1e-4), as in the original paper.
5. **Scene recovery** — `J = (I − A) / max(t, t₀) + A` with `t₀ = 0.1`, shown along with every intermediate (dark channel, raw and refined transmission).

## Usage

Open the folder in MATLAB and run:

```matlab
HazeRemoval
```

Replace `haze.jpg` to dehaze your own image.

**A note on speed:** the matting Laplacian is constructed with naive nested loops, so it is *slow* — the script downscales the input by 10× to keep the runtime tolerable. For production use, vectorize the Laplacian construction or swap step 4 for the guided filter (He et al., ECCV 2010), which is the standard fast replacement.

## License

MIT — see `LICENSE`.

## References

```bibtex
@article{he2011single,
  title={Single Image Haze Removal Using Dark Channel Prior},
  author={He, Kaiming and Sun, Jian and Tang, Xiaoou},
  journal={IEEE Transactions on Pattern Analysis and Machine Intelligence},
  volume={33},
  number={12},
  pages={2341--2353},
  year={2011}
}

@article{levin2008closed,
  title={A Closed-Form Solution to Natural Image Matting},
  author={Levin, Anat and Lischinski, Dani and Weiss, Yair},
  journal={IEEE Transactions on Pattern Analysis and Machine Intelligence},
  volume={30},
  number={2},
  pages={228--242},
  year={2008}
}
```
