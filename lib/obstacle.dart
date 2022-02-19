import 'package:flame/components.dart';
import 'package:flame/geometry.dart';

// Obstacle はゲーム中に存在する障害物を表します
// 本来的にはタイル毎に1と0のマップ作って1の場合は32*32のPositionComponentで当たり判定あるものおく、みたいな
// タイル毎にバラバラなObstacleをおくべき
class Obstacle extends PositionComponent with HasHitboxes, Collidable {
  Obstacle(Vector2 position, Vector2 size)
      : super(position: position, size: size, anchor: Anchor.topLeft);

  @override
  Future<void>? onLoad() {
    addHitbox(HitboxRectangle());
    return super.onLoad();
  }
}
