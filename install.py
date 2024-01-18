from os import environ, mkdir, symlink, walk, system
from os.path import abspath, isdir, isfile, join
from pathlib import Path
import sys

ENV = environ
HOME = ENV.get("HOME")
if HOME is None:
    print("YOU HAVE NO HOME!")
    sys.exit(1)
assert HOME is not None
HOME = Path(HOME)


CONFIG_DIR = Path(ENV.get("XDG_CONFIG_HOME", join(HOME, ".config")))
try:
    mkdir(CONFIG_DIR)
except:
    None
SYMLINK_BASE = "config"
DOTFILES = ["gitignore", "gitconfig", "gitmessage", "zshrc", "p10k.zsh"]
CARGO_INSTALLS = ["stylua", "fastmod"]


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


def build_dirs(_in: Path):
    created = False
    for base, dirs, files in walk(SYMLINK_BASE):
        base_p = Path(base)
        for d in dirs:
            _root, *rest = base_p.parts
            full_dir = join(*rest, d)
            if not isdir(_in / full_dir):
                _new = _in / full_dir
                print(f"Creating {_new}")
                mkdir(_new)
                created = True
    if not created:
        print("Looks like there was nothing to create!")


def connect_the_dirs(_to: Path):
    src_links = FileUtils.r_dirfiles("config")
    created = False
    for file in src_links:
        _root, *rest = file.parts
        destination = _to / Path(join(*rest))
        if isfile(destination):
            continue
        FileUtils.slink(abspath(file), destination)
        created = True
        print(f"Linking: {file} -> {destination}")
    if not created:
        print("Looks like there was nothing that needed to be linked!")


def connect_the_dots(home: Path):
    created = False
    for file in DOTFILES:
        dot = f".{file}"
        destination = home / dot
        if isfile(destination):
            print(f"Existing file for {dot}")
            continue
        FileUtils.slink(abspath(file), destination)
        print(f"Linking: {file} -> {destination}")
        created = True
    if not created:
        print("Looks like there was nothing that need to be linked!")


def install_cargos():
    for cargo in CARGO_INSTALLS:
        system(f"cargo install {cargo}")


if __name__ == "__main__":
    print(f"\nAttempting to created directories in {CONFIG_DIR}")
    build_dirs(CONFIG_DIR)

    print(f"\nAttempting to symlink into {CONFIG_DIR}")
    connect_the_dirs(CONFIG_DIR)

    print(f"\nAttempting to symlink dotfiles into {HOME}")
    connect_the_dots(HOME)

    print(f"\nAttempting to install cargos")
    install_cargos()
