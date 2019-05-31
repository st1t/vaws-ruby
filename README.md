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
   vaws ec2             # View ec2 instances
   vaws help [COMMAND]  # Describe available commands or one specific command
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

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Vaws project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/vaws/blob/master/CODE_OF_CONDUCT.md).
