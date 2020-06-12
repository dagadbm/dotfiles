git submodule foreach --recursive git reset --hard
git submodule update --recursive --remote --merge
git submodule foreach --recursive git reset --hard

# after updating the submodules you must re-run dotbo
./dotfiles.sh
