using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyMovement : MonoBehaviour
{
    public float verticalSpeed = 2f;
	public Vector2 verticalDirection = new Vector2(0f, -1f);
	public float horizontalSpeed = 0.1f;
	public Vector2 horizontalDirection = new Vector2(1f, 0f);

    void Update() {
		if (transform.position.y < -5) {
			Destroy(gameObject);
		}
		else {
			transform.Translate(verticalDirection * verticalSpeed * Time.deltaTime);
		}

		if ((transform.position.x < -2 && horizontalDirection.x < 0) || (transform.position.x > 2 && horizontalDirection.x > 0)) {
			horizontalDirection *= (-1f);
		} else {
			transform.Translate(horizontalDirection * horizontalSpeed * Time.deltaTime);
		}
    }
}
