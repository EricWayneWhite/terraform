Random Example
==============
This shows various uses of the random resource

Sample Output:
```
Outputs:

random_id = 9914b3e3481e1b6e
random_integer = 13
random_pet = pet-leech
random_shuffle = [
    us-west-1a,
    us-west-1b
]
random_string = 2*aQZDQXhDQ@FnB32kHL
random_uuid = d80722d0-a995-353c-4c5e-87ed2a75e601
```

<!--Start-->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| ami\_id | Reference to an AMI ID that, when changed, will trigger a new random ID when included in the keepers section | string | `"ami-061392db613a6357b"` | no |

## Outputs

| Name | Description |
|------|-------------|
| random\_id | Random ID |
| random\_integer | Random Integer |
| random\_pet | Random Pet |
| random\_shuffle | Random Shuffle |
| random\_string | Random String |
| random\_uuid | Random UUID |

<!--End-->
