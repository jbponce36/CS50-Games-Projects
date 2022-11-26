using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EnemyWeapon : MonoBehaviour
{
    public Transform firePoint;
    public GameObject bulletPrefab;
    public float shootingTimer;
    public float lastShoot = 4f;
    public float addedSpeed = 0f;

    void Start () {
        shootingTimer = Random.Range(0.5f, 2.5f);
    }
    
    void Update() {
        shootingTimer += Time.deltaTime;

        if (shootingTimer > lastShoot && !GetComponent<Enemy>().isDead) {
            if (Random.Range(0, 2) == 0) {
                Shoot();
            }
            shootingTimer = 0f;
        }
    }

    void Shoot() {
        GameObject bullet = Instantiate(bulletPrefab, firePoint.position, firePoint.rotation);
        bullet.GetComponent<EnemyBullet>().speed += addedSpeed;
    }
}
