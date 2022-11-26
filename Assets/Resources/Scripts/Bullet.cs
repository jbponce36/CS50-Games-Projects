using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Bullet : MonoBehaviour
{
    public float speed = 10.0f;
    public Rigidbody2D rb;
    public int damage = 40;
    public AudioSource shootSound;
    
    void Start() {
        rb.velocity = transform.up * speed;
        shootSound.Play();
    }

	void Update () {
		if (transform.position.y > 5f) {
			Destroy(gameObject);
		}
	}

    void OnTriggerEnter2D (Collider2D collider) {
        if (collider.CompareTag("Enemy")) {
            Enemy enemy = collider.GetComponent<Enemy>();
            if (enemy != null) {
                enemy.TakeDamage(damage);
            }
            
            if (enemy.isDead) {
                return;
            }
            
            Destroy(gameObject);
        }
    }
}
