locals {
  expanded_rules = flatten([
    for idx, rule in var.rules : [
      for sg in rule.security_group_id : { 
        rule = rule
        sg   = sg
      }
    ]
  ])
}

resource "aws_security_group_rule" "rules" {
  for_each = { for idx, rule in local.expanded_rules : idx => rule }

  type              = each.value.rule.type
  from_port         = each.value.rule.from_port
  to_port           = each.value.rule.to_port
  protocol          = each.value.rule.protocol
  security_group_id = each.value.sg

  cidr_blocks              = try(length(each.value.rule.cidr_blocks), 0) > 0 ? each.value.rule.cidr_blocks : null
  source_security_group_id = try(length(each.value.rule.source_security_group_id), 0) > 0 ? each.value.rule.source_security_group_id[0] : null

  lifecycle { create_before_destroy = true }
}



# resource "aws_security_group_rule" "rules" {
#   count = length(var.rules)

#   type              = var.rules[count.index].type
#   from_port         = var.rules[count.index].from_port
#   to_port           = var.rules[count.index].to_port
#   protocol          = var.rules[count.index].protocol
#   security_group_id = var.rules[count.index].security_group_id[0]

#   cidr_blocks              = try(length(var.rules[count.index].cidr_blocks), 0) > 0 ? var.rules[count.index].cidr_blocks : null
#   source_security_group_id = try(length(var.rules[count.index].source_security_group_id), 0) > 0 ? var.rules[count.index].source_security_group_id[0] : null

#   lifecycle { create_before_destroy = true }
# }
