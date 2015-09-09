#set -eu

npm install json
cp package.json package.json.bkp
mv ~/.npmrc ~/.npmrc.bkp

npm cache clean
npm config set registry https://clever.registry.nodejitsu.com/
npm config set strict-ssl true
npm config set always-auth true
auth=`echo -n ${npm_drone_username}:${npm_drone_password} | base64`
npm config set _auth $auth

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

echo "getting name"
name=`node node_modules/json/lib/json.js -f package.json name`
echo "got ${name}, updating name, publishing package"
if [[ $name == "@clever/"* ]]
then
  package_name=${name#$"@clever/"}
  echo "setting package name to ${package_name}"
  node node_modules/json/lib/json.js -I -f package.json -e "this.name='${package_name}'"
fi
node node_modules/json/lib/json.js -I -f package.json -e "this.publishConfig={registry:'https://clever.registry.nodejitsu.com'}"
npm publish

mv package.json.bkp package.json
mv ~/.npmrc.bkp ~/.npmrc
npm uninstall json
