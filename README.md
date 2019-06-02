# Vaws

The vaws command was created to simplify the display of AWS resources.

## Installation

```bash
$ gem install vaws
```

## Usage

```bash
$ vaws help
Commands:
  vaws alb             # View Application Loadbalarancers
  vaws ec2             # View EC2 instances
  vaws ecs             # View ECS
  vaws help [COMMAND]  # Describe available commands or one specific command
  vaws route53         # View Route53
  vaws subnet          # View Subnet
  vaws vpc             # View Vpc
```

### View EC2 Instances

```bash
$ vaws ec2
+---------+---------------------+-----------+----------+---------------+---------+
| Name    | Id                  | Type      | GlobalIp | PrivateIp     | Status  |
+---------+---------------------+-----------+----------+---------------+---------+
| web     | i-0ff37ae3axxxxxxxx | t3.micro  |          | 172.16.10.134 | stopped |
| app     | i-0f59bfba6xxxxxxxx | t3.medium |          | 172.16.10.232 | stopped |
+---------+---------------------+-----------+----------+---------------+---------+
$
```

### View ALB

```bash
$ vaws alb
+---------------------------------+-------------+-----------------+-----------------------+--------------------------------------------------+-----------------------------------------------------------------------------------+
| Name                            | Type        | Scheme          | Vpc                   | Short_Arn                                        | Dns                                                                               |
+---------------------------------+-------------+-----------------+-----------------------+--------------------------------------------------+-----------------------------------------------------------------------------------+
| hogehoge-nlb-internal           | network     | internal        | vpc-xxxxxxxx          | hogehoge-nlb-internal/xxxxxxxxxxxxxxx            | hogehoge-nlb-internal-xxxxxxxxxxxxxxxx.elb.ap-northeast-1.amazonaws.com           |
| fugafuga-alb-internal           | application | internet-facing | vpc-xxxxxxxx          | fugafuga-alb-internal/xxxxxxxxxxxxxxx            | fugafuga-alb-internal-xxxxxxxxxxxxxxxx.ap-northeast-1.elb.amazonaws.com           |
+---------------------------------+-------------+-----------------+-----------------------+--------------------------------------------------+-----------------------------------------------------------------------------------+
$ 
```

### View Subnet

```bash
$ vaws subnet
+------------------+--------------------------+-----------------+-----------------------+
| Cidr             | SubnetId                 | Az              | VpcId                 |
+------------------+--------------------------+-----------------+-----------------------+
| 172.16.10.0/24   | subnet-xxxxxxxx          | ap-northeast-1a | vpc-xxxxxxxx          |
+------------------+--------------------------+-----------------+-----------------------+
$ 
```

### View VPC

```bash
$ vaws vpc
+-----------------------+------------------+-------------------------+
| VpcId                 | Cidr             | Tags                    |
+-----------------------+------------------+-------------------------+
| vpc-xxxxxxxx          | 172.16.0.0/16    | default-vpc             |
+-----------------------+------------------+-------------------------+
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Vaws project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/vaws/blob/master/CODE_OF_CONDUCT.md).
