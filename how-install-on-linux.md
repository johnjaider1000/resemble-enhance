# Install on linux/Ubuntu

```bash
pyenv install 3.11.6

git clone git@github.com:johnjaider1000/resemble-enhance.git

pyenv global 3.11.6
pyenv virtualenv 3.11.6 resemble_env
pyenv activate resemble_env
#also you can activate with this: pyenv global resemble_env

pip install pydantic==1.10.8
pip install --upgrade gradio
pip install -r requirements.txt

# Ejecutar
python app.py
```

