ShellRecorder
-------------

Like [VCR](https://github.com/vcr/vcr) but for shelling out.

Record shell commands and replay them during test runs for faster and more
deterministic tests.

## Usage

```ruby
require "shell_recorder"

ShellRecorder.configure do |config|
  config.hook_into :open3
  config.storage_location = "fixtures/shell_recordings"
end

it "echo's sup" do
  ShellRecorder.use_recording("a slow shell command") do
    stdout, stderr, status = Open3.capture3("sleep 10 && echo sup")

    expect([stdout, stderr, status]).to eq(["sup\n", "", 0])
  end
end
```

Run the above test once, and `ShellRecorder` will record the output of the
command to to `spec/fixtures/shell_recordings/a_slow_shell_command.yml`. Run it
again and it will replay the slow shell command from the recorded fixture.


## Supported methods

Currently there is very basic support for:

- `Open3.capture3` (`stdout, stderr, status = Open3.capture3("pwd")`)
- ```Kernel#` ``` (```stdout = `pwd` ```)

## Status

This is in proof of concept stage, and not suitable to be used in the wild.

## Acknowledgements

I took a bunch of ideas and patterns from [VCR](https://github.com/vcr/vcr) and
[WebMock](https://github.com/bblimke/webmock)
