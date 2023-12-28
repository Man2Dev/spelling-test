# Spelling Training Script

This Bash script is designed to assist with spelling training by providing a tool to practice spelling words and sentences.

## Requirements
- Bash environment
- gtts-cli for text-to-speech conversion
- espeak-ng for text-to-speech conversion
- mpv for audio playback

## Usage
1. Clone this repository to your local machine.
2. Make sure the required utilities (gtts-cli, espeak-ng, mpv) are installed and available in the system path.
3. Execute the script by running ./spelling_train.sh in the terminal.

## Options
- -a: Enable text-to-speech output using espeak-ng.
- -b: Enable text-to-speech output using gtts-cli with audio playback through mpv.

## Usage Example
When prompted, enter the spelling of the prompted words or sentences, and follow the instructions to continue.

## File Structure
- word.txt: Input file containing words for spelling practice.
- correct.txt: Output file to store correctly spelled words or sentences.
- wrong.txt: Output file to store incorrectly spelled words or sentences.
- reread.txt: Output file to store words or sentences that need to be reread.

**Note**: Before executing the script, ensure the input files (word.txt) contain the words or sentences for the training.

## Contributing
- If you'd like to contribute to this project, feel free to fork the repository and submit a pull request.

## Copyright
spelling-test is released under version 3 or later of the GPL, the GNU General Public License
see the [license.txt](license.txt) file for details.

The author of spelling-test:

- Copyright (C) 2023-2023 Mohammadreza Hendiani `<mohammad.r.hendiani@gmail.com>`
