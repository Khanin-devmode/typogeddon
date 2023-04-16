import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(GameWidget(game: SpaceShooterGame()));
}

class SpaceShooterGame extends FlameGame with PanDetector {
  late Player player;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final playerSprite = await loadSprite('player-sprite.png');

    player = Player()
      ..sprite = playerSprite
      ..position = size / 2
      ..width = 100
      ..height = 100
      ..anchor = Anchor.center;

    add(player);
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    player.move(info.delta.game);
  }
}

// class Player extends PositionComponent {
//   static final _paint = Paint()..color = Colors.white;

//   @override
//   void render(Canvas canvas) {
//     canvas.drawRect(size.toRect(), _paint);
//   }

//   void move(Vector2 delta) {
//     position.add(delta);
//   }
// }

class Player extends SpriteComponent with HasGameRef<SpaceShooterGame> {
  void move(Vector2 delta) {
    position.add(delta);
  }
}
