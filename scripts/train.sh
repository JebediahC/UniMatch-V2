#!/bin/bash

# modify these augments if you want to try other datasets, splits or methods
# dataset: ['pascal', 'cityscapes', 'ade20k', 'coco']
# method: ['unimatch_v2', 'fixmatch', 'supervised']
# exp: just for specifying the 'save_path'
# split: ['92', '1_16', ...]. Please check directory './splits/$dataset' for concrete splits
dataset='gf7-building'
method='unimatch_v2'
exp='dinov2_base'
split='small_1_32'

config=configs/${dataset}.yaml
labeled_id_path=splits/$dataset/$split/labeled.txt
unlabeled_id_path=splits/$dataset/$split/unlabeled.txt
save_path=exp/$dataset/$method/$exp/$split

mkdir -p $save_path

# Train with specified number of GPUs (default: 1) and port (default: 29500)
NUM_GPUS=${1:-1}
PORT=${2:-29500}

python -m torch.distributed.launch \
    --nproc_per_node=$NUM_GPUS \
    --master_addr=localhost \
    --master_port=$PORT \
    $method.py \
    --config=$config --labeled-id-path $labeled_id_path --unlabeled-id-path $unlabeled_id_path \
    --save-path $save_path --port $PORT 2>&1 | tee $save_path/out.log
