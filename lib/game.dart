import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:flutter/material.dart';
import 'package:rpg/cat.dart';
import 'package:rpg/joystick.dart';
import 'package:rpg/obstacle.dart';
import 'package:rpg/world_map.dart';

class GameLoopWidget extends StatelessWidget {
  GameLoopWidget({Key? key}) : super(key: key);

  final gameLoop = GameLoop();

  @override
  Widget build(BuildContext context) {
    return GameWidget(
      game: gameLoop,
      loadingBuilder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class GameLoop extends FlameGame
    with HasCollidables, HasDraggables, HasCollidables {
  static double worldTileSize = 32;
  static double worldTileNumX = 40;
  static double worldTileNumY = 40;

  GameLoop() : super();

  @override
  Future<void>? onLoad() async {
    canvasSize.x = worldTileSize * worldTileNumX;
    canvasSize.y = worldTileSize * worldTileNumY;
    final tiledMap = await TiledComponent.load(
        'grassland.tmx', Vector2(worldTileSize, worldTileSize));
    add(WorldMap(tiledMap, Vector2(0, 0), Vector2(canvasSize.x, canvasSize.y)));
    final knobPaint = BasicPalette.blue.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();
    final joystick = JoystickController(knobPaint, backgroundPaint);
    await images.load('cat.png');
    final cat = Cat(joystick);
    camera.followComponent(cat);
    add(Obstacle(Vector2(worldTileSize * 5, worldTileSize * 16),
        Vector2(worldTileSize * 30, worldTileSize)));
    add(cat);
    add(joystick);
    await super.onLoad();
  }
}
