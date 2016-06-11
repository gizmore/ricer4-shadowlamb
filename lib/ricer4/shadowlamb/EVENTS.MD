Shadowlamb5 publish/arm_subscribe events
====================================
=== Player ===
> arm_subscribe('player/created') do |player|
> arm_subscribe('player/consumed/drink') do |player, drink|
> arm_subscribe('npc/created') do |npc|
=== Party ===
#> arm_subscribe('party/created') do |player|
> arm_subscribe('party/enters/area') do |party, old_area, new_area|
> arm_subscribe('party/leaves/area') do |party, old_area, new_area|
> arm_subscribe('party/enters/location') do |party, old_location, new_location|
> arm_subscribe('party/leaves/location') do |party, old_location, new_location|

=== Obstacles ===
> def sl5_on_using_with(object)
> def sl5_on_being_used(object)


=== NPC ===
> def sl5_npc_before_definition()
> def sl5_npc_after_definition()
> def sl5_npc_after_spawned_for(party)

