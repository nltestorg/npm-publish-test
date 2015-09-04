cp package.json package.json.bkp
#echo "getting name"
NAME=`json -f package.json name`
#echo "got ${NAME}, updating name"
json -I -f package.json -e "name='@clever/${NAME}'"
#echo "updated name, updating registry"
json -I -f package.json -e "publishConfig={registry:'https://registry.npmjs.org'}"
npm publish
mv package.json.bkp package.json
