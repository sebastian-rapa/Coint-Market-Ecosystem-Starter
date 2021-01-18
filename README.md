## Coin Market Advisor Ecosystem Starter

---
### Project Description
> Contains `CLI tools` that helps `set up` and `run` our ecosystem 

### Installation

---
#### 1. Go to Projects Directory
```shell
cd <pathDirectory> # Replace pathDirectory with the path to your Projects Directory  
```

#### 2. Clone git repository
```shell
git clone <repository> # Replace repository with the link from git hub
```

### Utilities: Description and Usage

---
#### setup-ecosystem.sh
- **Execute** the script `setup-ecosystem.sh`
- First it **checks** if the required software is installed on the machine;  
- Second it initializes git repositories needed in the ecosystem

---
#### run-ecosystem.sh
- **Execute** the script `run-ecosystem.sh`
- It starts 2 processes in the background;
- The 2 applications have logs the output inside their respectively directories inside the `logs.txt`
- You can fast check if the app are running by listing the port listeners using `lsof -i :[appProt]`
