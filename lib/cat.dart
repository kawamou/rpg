import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/sprite.dart';
import 'package:rpg/obstacle.dart';
import 'package:rpg/world_map.dart';

enum direction {
  up,
  right,
  down,
  left,
}

class Cat extends SpriteAnimationComponent
    with HasGameRef, HasHitboxes, Collidable {
  final JoystickComponent joystick;

  final double _animationSpeed = 0.15;

  late final SpriteAnimation _runDownAnimation;
  late final SpriteAnimation _runLeftAnimation;
  late final SpriteAnimation _runUpAnimation;
  late final SpriteAnimation _runRightAnimation;

  late direction currentDirection;

  bool _hasCollided = false;
  late direction _collisionDirection;

  late HitboxPolygon hitbox;

  Cat(this.joystick) : super(size: Vector2.all(32.0));

  @override
  void onCollisionEnd(Collidable other) {
    _hasCollided = false;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    if (other is WorldMap || other is Obstacle) {
      // TODO: これだけだと壁に設置したまま別の壁にぶつかったときにすり抜ける
      if (!_hasCollided) {
        _hasCollided = true;
        _collisionDirection = currentDirection;
      }
    }
  }

  @override
  Future<void>? onLoad() {
    _loadAnimations().then((_) => {animation = _runDownAnimation});
    position = gameRef.size / 2;
    addHitbox(HitboxRectangle());
    return super.onLoad();
  }

  Future<void> _loadAnimations() async {
    final spriteSheet = SpriteSheet(
      image: await gameRef.images.load('cat.png'),
      srcSize: Vector2(32.0, 32.0),
    );
    _runDownAnimation =
        spriteSheet.createAnimation(row: 0, stepTime: _animationSpeed, to: 3);
    _runLeftAnimation =
        spriteSheet.createAnimation(row: 1, stepTime: _animationSpeed, to: 3);
    _runRightAnimation =
        spriteSheet.createAnimation(row: 2, stepTime: _animationSpeed, to: 3);
    _runUpAnimation =
        spriteSheet.createAnimation(row: 3, stepTime: _animationSpeed, to: 3);
  }

  direction _currentDirection(double angle) {
    if (angle > -pi / 4 && angle <= pi / 4) {
      return direction.up;
    } else if (angle > pi / 4 && angle <= pi * (3 / 4)) {
      return direction.right;
    } else if (angle > pi * (3 / 4) && angle <= pi * (5 / 4)) {
      return direction.down;
    } else {
      return direction.left;
    }
  }

  Vector2 _updatePosition(direction d, Vector2 delta) {
    if (d == direction.up && canMoveUp()) {
      return Vector2(0.0, delta.y);
    } else if (d == direction.down && canMoveDown()) {
      return Vector2(0.0, delta.y);
    } else if (d == direction.right && canMoveRight()) {
      return Vector2(delta.x, 0.0);
    } else if (d == direction.left && canMoveLeft()) {
      return Vector2(delta.x, 0.0);
    } else {
      return Vector2(0.0, 0.0);
    }
  }

  SpriteAnimation _updateAnimation(direction d) {
    if (d == direction.up) {
      return _runUpAnimation;
    } else if (d == direction.right) {
      return _runRightAnimation;
    } else if (d == direction.down) {
      return _runDownAnimation;
    } else {
      return _runLeftAnimation;
    }
  }

  @override
  void update(double dt) {
    if (!joystick.delta.isZero()) {
      currentDirection = _currentDirection(joystick.delta.screenAngle());
      position.add(
          _updatePosition(currentDirection, joystick.relativeDelta * 300 * dt));
      animation = _updateAnimation(currentDirection);
    }
    super.update(dt);
  }

  bool canMoveUp() {
    if (_hasCollided && _collisionDirection == direction.up) {
      return false;
    }
    return true;
  }

  bool canMoveDown() {
    if (_hasCollided && _collisionDirection == direction.down) {
      return false;
    }
    return true;
  }

  bool canMoveLeft() {
    if (_hasCollided && _collisionDirection == direction.left) {
      return false;
    }
    return true;
  }

  bool canMoveRight() {
    if (_hasCollided && _collisionDirection == direction.right) {
      return false;
    }
    return true;
  }
}
