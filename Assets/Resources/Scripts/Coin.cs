using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Coin : MonoBehaviour
{
	public float speed = 2f;
    public int score = 500;
    
    void Update () {
		if (transform.position.y < -5) {
			Destroy(gameObject);
		}
		else {
			transform.Translate(0, -speed * Time.deltaTime, 0, Space.World);
		}
	}
    
    void OnTriggerEnter2D (Collider2D collider) {
        if (collider.CompareTag("Player")) {
            Pickup(collider);
        }
    }

    void Pickup (Collider2D player) {
        SoundManager.PlayCoinSound();
        GameMaster.AddScore(score);
        Destroy(gameObject);
    }
}
