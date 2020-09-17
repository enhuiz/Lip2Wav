import numpy as np
import tqdm
import argparse
from pathlib import Path

from synthesizer import audio
from synthesizer.hparams import hparams as hp

parser = argparse.ArgumentParser()
parser.add_argument("root", type=Path)
args = parser.parse_args()

paths = sorted(args.root.rglob("*.wav"))
for path in tqdm.tqdm(paths):
    specpath = path.parent / "mels.npz"
    wav = audio.load_wav(path, hp.sample_rate)
    spec = audio.melspectrogram(wav, hp)
    lspec = audio.linearspectrogram(wav, hp)
    np.savez_compressed(specpath, spec=spec, lspec=lspec)
