
docker-build:
	sudo docker build -t swifty buildenv
	sudo rm -rvf build
	bash -c "sudo docker run -a stdout -v $(CURDIR):/app1 --rm swifty:latest bash -c \"cd /app1 && ./buildenv/build.sh\""
clean:
	sudo docker image rm swifty