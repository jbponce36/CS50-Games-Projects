using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Boss : Enemy
{   
    public float changePatternAfterSeconds = 6f;
    public float stopAttackingForSeconds = 1.5f;
    public AudioSource introSound;

    void Start () {
        StartCoroutine(ChangePattern());
        StartCoroutine(SpawnPowerups());
        introSound.Play();
    }

    IEnumerator ChangePattern () {
        while (!GetComponent<Enemy>().isDead) {
            GetComponent<BossWeapon>().ChangeRandomPattern();

            yield return new WaitForSeconds(changePatternAfterSeconds);

            GetComponent<BossWeapon>().StopAttacking();

            yield return new WaitForSeconds(stopAttackingForSeconds);
        }
    }

    IEnumerator SpawnPowerups() {
        while (!GetComponent<Enemy>().isDead) {
            yield return new WaitForSeconds(Random.Range(6f, 10f));

            Instantiate(itemDropsPrefabs[Random.Range(0, itemDropsPrefabs.Length)], new Vector3(Random.Range(-2, 2), 6, 0), Quaternion.identity);
        }
    }

    public override void Die () {
        if (!isDead) {
            isDead = true;
            
            animator.SetTrigger("Dead");

            GameMaster.AddScore(score);

            GameMaster.BossDied(deadAnimationTime);

            Destroy(gameObject, deadAnimationTime);
        }
    }

    public override void OnTriggerEnter2D (Collider2D collider) {
        if (collider.CompareTag("Player") && !GetComponent<Enemy>().isDead && 
            !collider.GetComponent<Player>().isDead && !collider.GetComponent<Player>().isInvincible) {
                collider.GetComponent<Player>().Die();
        }
    }
}
