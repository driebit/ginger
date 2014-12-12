cd "modules";
for i in $(ls -d */); 
do 
  echo "Updating" ${i%%/};
  cd "${i%%}";
  git pull
  cd ..
done
