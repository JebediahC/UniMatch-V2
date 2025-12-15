# GF-7 Building Dataset Splits

本目录包含GF-7 Building 4-bands数据集的训练/验证/测试划分文件。

## 数据集统计

- **训练集**: 3,106 张图像
- **验证集**: 1,034 张图像
- **测试集**: 1,035 张图像
- **总计**: 5,175 张图像

## 划分说明

### 1. `val.txt` - 验证集
- 包含 1,034 张验证图像
- 用于模型验证和超参数调整

### 2. `test.txt` - 测试集
- 包含 1,035 张测试图像
- 用于最终模型评估

### 3. `all/` - 全监督训练
- `labeled.txt`: 3,106 张带标签的训练图像
- 适用于全监督学习场景

### 4. `1_32/` - 半监督训练 (1/32 标注比例)
- `labeled.txt`: 97 张带标签图像 (约 3.1%)
- `unlabeled.txt`: 3,009 张无标签图像 (约 96.9%)
- 适用于半监督学习，标注数据有限的场景

### 5. `1_64/` - 半监督训练 (1/64 标注比例)
- `labeled.txt`: 48 张带标签图像 (约 1.5%)
- `unlabeled.txt`: 3,058 张无标签图像 (约 98.5%)
- 适用于半监督学习，极少标注数据的场景

### 6. `small_1_32/` - 快速测试 (1/100数据量)
- `labeled.txt`: 1 张带标签图像
- `unlabeled.txt`: 30 张无标签图像
- 用于快速测试代码和调试，不建议用于正式训练

### 7. `small_1_64/` - 快速测试 (1/100数据量)
- `labeled.txt`: 1 张带标签图像
- `unlabeled.txt`: 30 张无标签图像
- 用于快速测试代码和调试，不建议用于正式训练

## 文件格式

每行包含两个路径，用空格分隔：
```
<image_path> <label_path>
```

示例：
```
Train/image/Chongqing_1.tif Train/label/Chongqing_1.tif
Val/image/Guangzhou_10.tif Val/label/Guangzhou_10.tif
```

## 使用方法

### 在UniMatch-V2中使用

1. 将splits文件放在 `UniMatch-V2/splits/gf7-building/` 目录
2. 在配置文件中指定数据路径和splits：

```yaml
dataset:
  type: gf7-building
  data_root: data/gf-7-building-4bands
  splits_dir: splits/gf7-building
  
  # 选择不同的训练模式：
  
  # 全监督
  train_split: all/labeled.txt
  
  # 半监督 1/32
  labeled_split: 1_32/labeled.txt
  unlabeled_split: 1_32/unlabeled.txt
  
  # 半监督 1/64
  # labeled_split: 1_64/labeled.txt
  # unlabeled_split: 1_64/unlabeled.txt
  
  val_split: val.txt
```

## 生成脚本

可以使用 `generate_gf7_splits.py` 重新生成这些划分文件：

```bash
python3 generate_gf7_splits.py
```

脚本特点：
- 使用固定随机种子 (seed=42)，确保可重现
- 自动计算标注/未标注比例
- 支持自定义划分比例

## 注意事项

1. **数据路径**: 所有路径都是相对于数据集根目录 `data/gf-7-building-4bands/`
2. **随机划分**: labeled/unlabeled的划分使用固定随机种子，保证结果可重现
3. **标签格式**: 图像和标签使用相同的文件名，都是 `.tif` 格式
4. **small splits**: 仅用于快速测试，数据量太小不适合真实训练

## 数据集来源

GF-7 Building 4-bands 数据集包含来自中国多个城市的高分辨率卫星图像：
- 重庆 (Chongqing)
- 广州 (Guangzhou)
- 兰州 (Lanzhou)
- 宁波 (Ningbo)
- 深圳 (Shenzhen)
- 天津 (Tianjin)
