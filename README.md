# Vaws

The vaws command was created to simplify the display of AWS resources.

# !!!!WARNING!!!!

I am working on a project to rewrite Ruby to Go.  
https://github.com/st1t/vaws  

Therefore, this repository is now archived.  
Changed the repository name from vaws to vaws-ruby.

## Installation

```bash
$ gem install vaws
```

## Usage

```bash
$ vaws help
Commands:
  vaws acm             # View ACM
  vaws alb             # View Application Loadbalarancers
  vaws ec2             # View EC2 instances
  vaws ecs             # View ECS
  vaws help [COMMAND]  # Describe available commands or one specific command
  vaws route53         # View Route53
  vaws sg              # View Security Group
  vaws ssm             # View SSM Parameter store
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

### View Security Group

```bash
s$ bundle exec ruby exe/vaws sg
+----------------+----------------------+----------------------------------+----------+
| Name           | Id                   | Inbound(Cidr|Securitygroup:Port) | Protocol |
+----------------+----------------------+----------------------------------+----------+
| allow_all      | sg-00bc9e3b5b628e40a | sg-00bc9e3b5b628e40a:all         | all      |
|                |                      | 1.2.3.4/32:all                   | all      |
| global-lb      | sg-09f5aede801b4ab4a | 0.0.0.0/0:80                     | tcp      |
|                |                      | 0.0.0.0/0:443                    | tcp      |
+----------------+----------------------+----------------------------------+----------+
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

### View Route53

```bash
$ vaws route53
# ZONE LIST
0:st1t.com.
1:st1t.internal.
zone number: 0
+----------------------------------------------------------+-------+------------------------------------------------------------------------------+--------+
| Fqdn                                                     | Type  | Value                                                                        | Ttl    |
+----------------------------------------------------------+-------+------------------------------------------------------------------------------+--------+
| st1t.com.                                                | NS    | ns-468.awsdns-58.com.                                                        | 172800 |
|                                                          |       | ns-599.awsdns-10.net.                                                        |        |
|                                                          |       | ns-2009.awsdns-59.co.uk.                                                     |        |
|                                                          |       | ns-1527.awsdns-62.org.                                                       |        |
| st1t.com.                                                | SOA   | ns-468.awsdns-58.com. awsdns-hostmaster.amazon.com. 1 7200 900 1209600 86400 | 900    |
| www.st1t.com.                                            | CNAME | hatenablog.com.                                                              | 300    |
+----------------------------------------------------------+-------+------------------------------------------------------------------------------+--------+
$ 
```

### SSM Parameter Store

```bash
$ vaws ssm
+-----------------------------------------------+--------------+---------+---------------------------+
| Path                                          | Type         | Version | LastModifyDate            |
+-----------------------------------------------+--------------+---------+---------------------------+
| /st1t/hoge                                    | String       | 26      | 2020-03-01 12:49:54 +0900 |
| /st1t/fuga                                    | String       | 26      | 2020-03-01 12:49:54 +0900 |
+-----------------------------------------------+--------------+---------+---------------------------+
$
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Vaws project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/vaws/blob/master/CODE_OF_CONDUCT.md).
