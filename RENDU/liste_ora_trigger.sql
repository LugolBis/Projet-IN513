select
table_name,
trigger_name,
triggering_event,
trigger_type,
status,
description
from user_triggers
order by table_name, trigger_name;