### App Pipeline

To Do:
1. Document the pipeline and dockerfile definitions
2. Define a Dockerfile - Done
3. Setup a pipeline using BuildKite ~~or Github actions~~
4. Improve the health api - Done
5. ~~Add tests for metrics and health APIs~~


Fixes Made to App:
1. Defined stats map in main.go
2. Updated token function to return json in handler.go
3. 

```
For build purposes, use export SECRET=<value> and thenpass it as an arg using command:
       docker build --tag <image-name>:latest . --file app/Dockerfile --build-arg secret=$SECRET
Run the above cmd from root directory of this repo
```