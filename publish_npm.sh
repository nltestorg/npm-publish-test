set -eu

echo "${npm_drone_username}" > npm_credentials
echo "${npm_drone_password}" >> npm_credentials
echo "${npm_drone_email}" >> npm_credentials

npm cache clean
npm config set registry https://registry.npmjs.org
npm config set strict-ssl true
npm config set always-auth true
npm login < npm_credentials && rm npm_credentials

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
