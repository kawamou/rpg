import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame_tiled/flame_tiled.dart';

class WorldMap extends PositionComponent with HasHitboxes, Collidable {
  TiledComponent tiledMap;
  WorldMap(this.tiledMap, Vector2 position, Vector2 size)
      : super(position: position, size: size, anchor: Anchor.topLeft);

  @override
  Future<void>? onLoad() {
    add(tiledMap);
    addHitbox(HitboxRectangle());
    return super.onLoad();
  }
}
