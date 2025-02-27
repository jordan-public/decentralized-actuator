import getpass
import os
from langchain.tools import BaseTool
from langchain.agents import initialize_agent
from langchain.llms import OpenAI


if not os.environ.get("OPENAI_API_KEY"):
  os.environ["OPENAI_API_KEY"] = getpass.getpass("Enter API key for OpenAI: ")
  
class GreetTool(BaseTool):
    name: str = "greet"
    description: str = "A tool to greet someone by name."

    def _run(self, name: str) -> str:
        return f"Hello, {name}!"

    async def _arun(self, name: str) -> str:
        return self._run(name)
    
# Initialize your LLM
llm = OpenAI(temperature=0)

# Create an agent with your custom tool.
tools = [GreetTool()]
agent = initialize_agent(tools, llm, model_name="gpt-4o-mini", agent="zero-shot-react-description", verbose=True)

response = agent.run("Greet Bob")
print(response)