module Ricer4::Plugins::Shadowlamb::Core::Include::Collision
  # var XAsum = A.LngStart - A.LngEnd;
# var XBsum = B.LngStart - B.LngEnd;
# var YAsum = A.LatStart - A.LatEnd;
# var YBsum = B.LatStart - B.LatEnd;
# 
# var LineDenominator = XAsum * YBsum - YAsum * XBsum;
# if(LineDenominator == 0.0)
    # return false;
# 
# var a = A.LngStart * A.LatEnd - A.LatStart * A.LngEnd;
# var b = B.LngStart * B.LatEnd - B.LatStart * B.LngEnd;
# 
# var x = (a * XBsum - b * XAsum) / LineDenominator;
# var y = (a * YBsum - b * YAsum) / LineDenominator;

  def party_movement_intersects?(moving, check)
    return false unless (check.is_moving?) && (moving.area == check.area)

    return true    
    
  end

end