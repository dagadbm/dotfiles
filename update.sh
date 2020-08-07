git submodule foreach --recursive git reset --hard
git submodule update --recursive --remote --merge
git submodule foreach --recursive git reset --hard

# after updating the submodules you must re-run dotbo
./dotbot.sh

## upgrade nvim
nvim +PlugInstall +PlugUpdate +CocInstall +CocUpdateSync +CocRebuild +qall

## upgrade brew
brew update && brew upgrade
