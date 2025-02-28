import getpass
import os
import subprocess
from langchain.tools import BaseTool
from langchain.agents import initialize_agent
from langchain.llms import OpenAI


if not os.environ.get("OPENAI_API_KEY"):
  os.environ["OPENAI_API_KEY"] = getpass.getpass("Enter API key for OpenAI: ")
  
class ActionTool(BaseTool):
    name: str = "action"
    description: str = "A tool to take an action by name."

    def _run(self, name: str) -> str:
      command = ["../request.sh", "action"]
      result = subprocess.run(command, capture_output=True, text=True)
      return result.stdout + result.stderr

    async def _arun(self, name: str) -> str:
        return self._run(name)
    
# Initialize your LLM
llm = OpenAI(temperature=0)

# Create an agent with your custom tool.
tools = [ActionTool()]
agent = initialize_agent(tools, llm, model_name="gpt-4o-mini", agent="zero-shot-react-description", verbose=True)

response = agent.run("Perform the action of feeding the Bufficon")
print(response)