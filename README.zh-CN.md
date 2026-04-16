[English](./README.md)

# Ralph Skills For Codex

Ralph 是一套面向 Codex 的工作流，用来把一个功能想法整理成 PRD，再把 PRD 转成 `ralph/prd.json`，最后在目标项目里运行自动实现循环。

## 前置条件

- 已安装并登录 Codex CLI
- 已安装 `jq`
- 目标项目是一个 git 仓库

## 仓库结构

| 路径 | 用途 |
|------|------|
| `skills/ralph-prd/` | 交互式澄清需求，并生成 `tasks/prd-[feature-name].md` |
| `skills/ralph-json/` | 把 Ralph PRD markdown 转成 `./ralph/prd.json` |
| `skills/ralph-json/resources/` | 复制到目标项目 `./ralph/` 下的运行时文件 |
| `.agents/skills/` | 供本地 Codex 测试使用的项目级 skill |

## 完整流程

推荐流程如下：

1. 先把 `ralph-prd` 和 `ralph-json` 安装到目标项目，或者安装到全局 Codex skills 目录。
2. 在 Codex 中运行 `ralph-prd`，生成 `tasks/prd-[feature-name].md`。
3. 在 Codex 中运行 `ralph-json`，把该 PRD 转成 `./ralph/prd.json`。
4. 在目标项目根目录执行 `./ralph/ralph.sh`，启动实现循环。

`ralph-json` 在写入 `./ralph/prd.json` 之前，还负责确保下面两个运行时文件已经存在：

- `./ralph/ralph.sh`
- `./ralph/CODEX.md`

如果其中任意文件缺失，`ralph-json` 应从 `skills/ralph-json/resources/` 复制过来，并执行：

```bash
chmod +x ./ralph/ralph.sh
```

## 第一步：安装两个 Skill

### 安装到项目内

如果你希望目标项目自带 Ralph skills，用这个方式：

```bash
mkdir -p .agents/skills
cp -r /path/to/ralph-codex/skills/ralph-prd .agents/skills/ralph-prd
cp -r /path/to/ralph-codex/skills/ralph-json .agents/skills/ralph-json
```

项目内的 `.agents/skills/` 会优先于全局 skills 生效。

### 全局安装

如果你希望所有项目都能直接使用这些 skills，用这个方式：

```bash
mkdir -p ~/.agents/skills
cp -r /path/to/ralph-codex/skills/ralph-prd ~/.agents/skills/ralph-prd
cp -r /path/to/ralph-codex/skills/ralph-json ~/.agents/skills/ralph-json
```

## 第二步：运行 `ralph-prd`

在目标项目对应的 Codex 会话里调用 `ralph-prd`。

预期输出：

- `tasks/prd-[feature-name].md`

`ralph-prd` 会做的事：

- 提问澄清需求
- 生成结构化 PRD
- 只负责规划，不会开始实现

## 第三步：运行 `ralph-json`

在同一个目标项目的 Codex 会话里调用 `ralph-json`，并指向上一步生成的 PRD。

预期输出：

- `./ralph/prd.json`

`ralph-json` 会做的事：

- 读取 `tasks/prd-[feature-name].md`
- 把用户故事转成有序的 JSON stories
- 确保 `./ralph/ralph.sh` 和 `./ralph/CODEX.md` 已存在
- 如果脚本是刚复制进来的，会把 `./ralph/ralph.sh` 设为可执行

执行完这一步后，项目里通常会有：

- `tasks/prd-[feature-name].md`
- `./ralph/prd.json`
- `./ralph/ralph.sh`
- `./ralph/CODEX.md`

## 第四步：运行 `./ralph/ralph.sh`

在目标项目根目录执行：

```bash
./ralph/ralph.sh
```

或者显式指定迭代次数上限：

```bash
./ralph/ralph.sh 10
```

### 脚本参数

`./ralph/ralph.sh [max_iterations]`

- `max_iterations`：可选的正整数参数
- 默认值：`10`

行为说明：

- 不传参数时，Ralph 会按 `10` 次迭代运行
- 传参时，必须是数字，例如 `5`、`10`、`20`
- 如果传入超过一个参数，脚本会打印 usage 并退出
- 如果参数不是数字，脚本也会打印 usage 并退出

### `ralph.sh` 运行期间会生成的文件

脚本运行时，可能创建或更新：

- `./ralph/progress.txt`
- `./ralph/.last-branch`
- `./ralph/archive/`

真正的实现改动发生在项目根目录，不是在 `./ralph/` 目录里。

## 最小示例

在目标项目里：

1. 安装 `ralph-prd` 和 `ralph-json`
2. 运行 `ralph-prd`
3. 把结果保存为 `tasks/prd-my-feature.md`
4. 运行 `ralph-json`
5. 生成 `./ralph/prd.json`
6. 运行 `./ralph/ralph.sh 10`

## 验证

smoke test 在 `tests/codex_wrapper_smoke.sh`。

执行方式：

```bash
bash tests/codex_wrapper_smoke.sh
```
