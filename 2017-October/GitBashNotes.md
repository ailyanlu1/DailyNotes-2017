## Git Bash Notes

cd C:\omi

cd ostc-automation/

git clone https://github.com/Microsoft/ostc-automation

cd ostc-automation/

git fetch

git pull origin master

git reset --hard HEAD

### Add and Push

git status -s

git add .

git commit . -m 'Add Linux to Win test code for OMI'

git push origin yourbranch -f

### Merge 

git checkout master

git fetch

git pull origin master

git rebase yourbranch

git push origin master

### Reset

git reset --soft HEAD~


git log

git config --global --edit


git config --global user.name "AllenZhangSh"

git config --global user.email "v-zhshua@microsoft.com" 
