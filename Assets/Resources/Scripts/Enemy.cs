using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Enemy : MonoBehaviour
{
    public int health = 100;
    public int score = 100;
    public Animator animator;
    public float deadAnimationTime;
    public GameObject[] itemDropsPrefabs;
    public bool isDead = false;
    public AudioSource explosionSound;

    public virtual void TakeDamage (int damage) {
        health -= damage;

        animator.SetTrigger("Hurt");

        if (health <= 0) {
            Die();
        }
    }

    public virtual void Die () {
        if (!isDead) {
            isDead = true;
            
            animator.SetTrigger("Dead");
            
            if (itemDropsPrefabs.Length > 0) {
                Instantiate(itemDropsPrefabs[Random.Range(0, itemDropsPrefabs.Length)], transform.position, Quaternion.identity);
            }

            GameMaster.AddScore(score);

            explosionSound.Play();

            Destroy(gameObject, deadAnimationTime);
        }
    }

    public virtual void OnTriggerEnter2D (Collider2D collider) {
        if (collider.CompareTag("Player") && !isDead && !collider.GetComponent<Player>().isDead) {
            collider.GetComponent<Player>().Hurt();
        }
    }
}
