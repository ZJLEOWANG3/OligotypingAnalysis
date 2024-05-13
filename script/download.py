#!/home/a.onnis-hayden/.local/env/python-3.11-venv-generic/bin/python3
#SBATCH -J download
#SBATCH -o download.log
#SBATCH -p short -c 1 -N 1 --time 24:00:00

import argparse
import json
import os
import subprocess
import sys


def get_args():
	ap = argparse.ArgumentParser()
	ap.add_argument("input", type=str,
		help="input NCBI FTP metadata json file")
	ap.add_argument("-O", "--output-dir", type=str, default=".",
		metavar="dir",
		help="output directory [.]")
	# parse and refine args
	args = ap.parse_args()
	return args


def download_by_metadata(metadata: dict, out_dir: str) -> None:
	for url in metadata["files"]:
		print("downloading: %s" % url, file=sys.stderr)
		ofile = os.path.join(out_dir, url.split("/")[-1])
		cmd = ["wget", "-O", ofile, url]
		subprocess.check_call(cmd)
	return


def main():
	args = get_args()
	mdata = json.load(open(args.input, "r"))
	download_by_metadata(mdata, args.output_dir)
	return


if __name__ == "__main__":
	main()
