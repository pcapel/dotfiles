import sys
from os import environ, symlink, walk, mkdir
from os.path import join, abspath, isdir, isfile
from pathlib import Path

# TODO: In order to install the fonts, I will need requests
# TODO: In order to get requests, I should have poetry
# TODO: In order to get poetry, I should use a shell or brew
# TODO: I need to move over a brew script...
#FONT_URLS = ['https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/CascadiaCode/Regular/complete/Caskaydia%20Cove%20Nerd%20Font%20Complete%20Mono%20Regular.otf',
#      'https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/CascadiaCode/Regular/complete/Caskaydia%20Cove%20Nerd%20Font%20Complete%20Mono%20Italic.otf',
#      'https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/CascadiaCode/Bold/complete/Caskaydia%20Cove%20Nerd%20Font%20Complete%20Mono%20Bold.otf',
#      ]
#FONTS_DIR = f'{HOME}/Library/Fonts'
###################################################################################################################################################################################################

ENV = environ
HOME = ENV.get("HOME")
if HOME is None:
    print('YOU HAVE NO HOME!')
    sys.exit(1)

CONFIG_DIR = Path(ENV.get("XDG_CONFIG_HOME", join(HOME, '.config')))
print(CONFIG_DIR)
SYMLINK_BASE = 'config'

# Build out the directories for the configs to live in
for base, dirs, files in walk(SYMLINK_BASE):
    base_p = Path(base)
    for d in dirs:
        # TODO: interesting pattern?
        _root, *rest = base_p.parts
        full_dir = join(*rest, d)
        if not isdir(CONFIG_DIR / full_dir):
            mkdir(CONFIG_DIR / full_dir)

class FileUtils:
    @staticmethod
    def r_dirfiles(directory):
        return [
                    Path(join(base, file))
                    for base, dirs, files in walk(SYMLINK_BASE)
                    for file in files
                ]

    @staticmethod
    def slink(src, target):
        """Absolute paths"""
        if isfile(target):
            return False
        else:
            symlink(src, target)
        return True


src_links = FileUtils.r_dirfiles('config')
for file in src_links:
    _root, *rest = file.parts
    destination = CONFIG_DIR / Path(join(*rest))
    FileUtils.slink(abspath(file), destination)

