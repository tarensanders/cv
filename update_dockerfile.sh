docker build --build-arg GITHUB_PAT=$GITHUB_PAT -t tarensanders/cv:latest .
docker push tarensanders/cv:latest
