set -eu

npm cache clean
echo "//registry.npmjs.org/:_authToken=${npm_publish_token}" > ~/.npmrc
npm config set registry https://registry.npmjs.org
npm config set strict-ssl true
npm config set always-auth true

cat ~/.npmrc
npm config list
readlink -f ~/.npmrc

cp package.json package.json.bkp
current_commit=`git log -1 HEAD --pretty=format:"%H"`
master_commit=`git log -1 master --pretty=format:"%H"`
git branch
echo "current_commit is '${current_commit}'"
echo "master_commit is '${master_commit}'"
if [ "${current_commit}" != ${master_commit} ]
then
  echo "only works on master branch!"
  exit
fi

npm install json
echo "getting name"
name=`node node_modules/json/lib/json.js -f package.json name`
echo "got ${name}, updating name, publishing package"
node node_modules/json/lib/json.js -I -f package.json -e "name='@clever/${name}'" && node node_modules/json/lib/json.js -I -f package.json -e "publishConfig={registry:'https://registry.npmjs.org'}" && npm publish
npm uninstall json
mv package.json.bkp package.json
