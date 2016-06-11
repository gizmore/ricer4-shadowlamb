module Ricer4::Plugins::Shadowlamb::Core::Areas::Extend::WalletFound
  def maybe_found_wallet(party)
    party.members.each do |player|
      wallet_found!(player) if wallet_found?(player)
    end
  end
  
  def wallet_found?(player)
    dice_against_percent(wallet_chance(player))
  end

  def wallet_found!(player)
    nuyen = wallet_nuyen(player)
    player.give_nuyen(nuyen)
    player.send_message(t(:msg_wallet_found, nuyen_found: nuyen, nuyen_now: player.nuyen))
  end
  
  def wallet_nuyen(player)
    min, max = 5, player.get_adjusted(:luck) * 2
    rand(min, min+max)
  end
  
  def wallet_chance(player)
    luck = player.get_adjusted(:luck)
    chance = (0.5 + luck * 0.2).clamp_max(3)
  end
  
end
