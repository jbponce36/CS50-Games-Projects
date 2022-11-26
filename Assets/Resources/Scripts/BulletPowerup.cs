using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BulletPowerup : MonoBehaviour
{
	public float speed = 2f;
    public int score = 1000;
    
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
        SoundManager.PlayPowerupSound();
        GameMaster.AddScore(score);
        player.GetComponent<Player>().PickupBulletPowerup();
        Destroy(gameObject);
    }
}
