import sys
import yaml

env_dict = {}
with open('.env', 'r') as f:
    for line in f:
        line = line.strip()
        if not line or line.startswith('#'):
            continue
        parts = line.split('=', 1)
        if len(parts) == 2:
            key = parts[0].strip()
            val = parts[1].strip()
            env_dict[key] = val

with open('env.yaml', 'w') as f:
    yaml.dump(env_dict, f)
