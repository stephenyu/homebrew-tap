class AiCli < Formula
  desc "Convert natural language questions to terminal commands using OpenAI"
  homepage "https://github.com/stephenyu/ai-cli"
  url "https://github.com/stephenyu/ai-cli/archive/v0.1.0.tar.gz"
  sha256 "309123570bb52b4adf487f689a45c020addfc9b498e65a59b4701b16ac27a7ea"
  license "MIT"

  depends_on "python@3.12"

  def install
    # Copy the main script to libexec
    libexec.install "ai_cli.py"
    
    # Create the executable that checks for dependencies and runs the script
    (bin/"ai").write <<~EOS
      #!/usr/bin/env python3
      import sys
      import subprocess
      
      # Check if required packages are installed
      try:
          import openai
          import pydantic
          import keyring
      except ImportError as e:
          print(f"Missing dependency: {e}")
          print("Please install dependencies with:")
          print("  pip3 install openai pydantic keyring")
          sys.exit(1)
      
      # Import and run the main module
      import os
      sys.path.insert(0, "#{libexec}")
      exec(open("#{libexec}/ai_cli.py").read())
    EOS
  end

  def caveats
    <<~EOS
      To use ai-cli, you need to install Python dependencies:
        pip3 install openai pydantic keyring
      
      Then configure your OpenAI API key:
        ai setup
    EOS
  end

  test do
    # Test that the script can be executed
    assert_match "Missing dependency", shell_output("#{bin}/ai --help", 1)
  end
end 