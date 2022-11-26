using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyBullet : MonoBehaviour
{
    public float speed = 10.0f;
    public Rigidbody2D rb;
    public Vector2 direction = new Vector2(0f, -1f);
    public AudioSource shootSound;
    
    void Start() {
        rb.velocity = direction * speed;
        shootSound.Play();
    }

	void Update () {
		if (transform.position.x < -10f || transform.position.x > 10f || 
            transform.position.y < -6f || transform.position.y > 6f) {
			Destroy(gameObject);
		}
	}

    void OnTriggerEnter2D (Collider2D collider) {
        if (collider.CompareTag("Player") && 
            !collider.GetComponent<Player>().isDead && !collider.GetComponent<Player>().isInvincible) {
                collider.GetComponent<Player>().Hurt();
                Destroy(gameObject);
        }
    }
}
