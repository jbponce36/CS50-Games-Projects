using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Weapon : MonoBehaviour {

    public Transform firePoint;
    public Transform leftFirePoint;
    public Transform rightFirePoint;
    public GameObject bulletPrefab;
    public GameObject smallBulletPrefab;
    public bool fire = false;
    public float shootingTimer = 0;
    public float lastShoot = 1f;

    public int bulletType = 1;

    void Update() {

        shootingTimer += Time.deltaTime;

        if (Input.GetButtonDown("Fire1")) {
            fire = true;
        }

        if (Input.GetButtonUp("Fire1")) {
            fire = false;
        }

        if (fire && shootingTimer > lastShoot) {
            Shoot();
            shootingTimer = 0;
        }
    }

    void Shoot() {
        if (bulletType == 1) {
            Instantiate(smallBulletPrefab, firePoint.position, firePoint.rotation);

        } else if (bulletType == 2) {
            Instantiate(smallBulletPrefab, leftFirePoint.position, leftFirePoint.rotation);
            Instantiate(smallBulletPrefab, rightFirePoint.position, rightFirePoint.rotation);

        } else if (bulletType == 3) {
            Instantiate(bulletPrefab, firePoint.position, firePoint.rotation);
            Instantiate(smallBulletPrefab, leftFirePoint.position, leftFirePoint.rotation);
            Instantiate(smallBulletPrefab, rightFirePoint.position, rightFirePoint.rotation);
        }

        GetComponent<FollowerSpawner>().Shoot();
    }

    public void IncrementBulletType() {
        if (bulletType < 3) {
            bulletType++;
        }
    }
}
