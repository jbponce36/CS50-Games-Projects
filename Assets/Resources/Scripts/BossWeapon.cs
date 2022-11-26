using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BossWeapon : MonoBehaviour
{
    public Transform firePoint;
    public GameObject[] bulletPrefabs;
    public float canShootTimer = 0f;
    public float shootingTimer = 0f;
    public float shootAfterSeconds = 1f;

    public float numberOfBullets = 24f;

    public float currentAngle = 270f;
    public float currentAngleR = 270f;

    public float numberOfStarPoints = 5f;

    public enum AttackPattern {Circle, Star, Spiral, SpiralReverse, Forward, Nothing};
    public AttackPattern currentAttack = AttackPattern.Nothing;

    public int patternAlternation = 0;

    void Update() {
        if (canShootTimer < 6f) {
            canShootTimer += Time.deltaTime;
            return;
        }

        shootingTimer += Time.deltaTime;

        if (shootingTimer > shootAfterSeconds && !GetComponent<Enemy>().isDead) {
            Shoot(currentAttack);
            shootingTimer = 0f;
        }
    }
    
    public void StopAttacking () {
        currentAttack = AttackPattern.Nothing;
    }

    public void ChangeRandomPattern () {
        currentAttack = (AttackPattern)Random.Range(0, 5);
    }

    public void Shoot(AttackPattern attack) {
        if (attack == AttackPattern.Circle)
            AlternateCirclePatterns();
        else if (attack == AttackPattern.Spiral)
            ShootSpiral();
        else if (attack == AttackPattern.SpiralReverse)
            ShootSpiralReverse();
        else if (attack == AttackPattern.Star)
            AlternateStarPatterns();
        else if (attack == AttackPattern.Forward)
            ShootForward();
        else if (attack == AttackPattern.Nothing)
            return;
    }

    void AlternateCirclePatterns() {
        if (patternAlternation == 0) {
            ShootCircle();
            patternAlternation++;
        } else {
            numberOfBullets += 2;
            ShootCircle();
            numberOfBullets -= 2;
            patternAlternation--;
        }
    }

    void AlternateStarPatterns() {
        if (patternAlternation == 0) {
            ShootStar();
            patternAlternation++;
        } else {
            numberOfBullets++;
            numberOfStarPoints++;
            ShootStar();
            numberOfBullets--;
            numberOfStarPoints--;
            patternAlternation--;
        }
    }

    void ShootCircle() {
        shootAfterSeconds = 1f;
        for (int i = 0; i < numberOfBullets; i++) {
            float newDirectionX = Mathf.Cos(Mathf.PI * 2 * i / numberOfBullets);
            float newDirectionY = Mathf.Sin(Mathf.PI * 2 * i / numberOfBullets);
            
            GameObject bullet = Instantiate(bulletPrefabs[2], firePoint.position, firePoint.rotation);

            bullet.GetComponent<EnemyBullet>().direction = new Vector2(newDirectionX, newDirectionY).normalized;

            Vector3 rotationVector = Vector3.forward * 360 * i /numberOfBullets + Vector3.forward * 90;
            bullet.transform.Rotate(rotationVector);
        }
    }

    void ShootStar() {
        shootAfterSeconds = 1.5f;
        for (int i = 0; i < numberOfBullets; i++) {
            float newDirectionX = Mathf.Cos(Mathf.PI * 2f * i / numberOfBullets);
            float newDirectionY = Mathf.Sin(Mathf.PI * 2f * i / numberOfBullets);
            
            GameObject bullet = Instantiate(bulletPrefabs[1], firePoint.position, firePoint.rotation);

            bullet.GetComponent<EnemyBullet>().direction = new Vector2(newDirectionX, newDirectionY).normalized;

            float addVelocity = Mathf.Abs(Mathf.Sin(numberOfStarPoints * (i*(360f / numberOfBullets)-90f) * (Mathf.PI / 360f)));
            bullet.GetComponent<EnemyBullet>().speed += addVelocity;

            Vector3 rotationVector = Vector3.forward * 360f * i /numberOfBullets + Vector3.forward * 90f;
            bullet.transform.Rotate(rotationVector);
        }
    }

    void ShootSpiral() {
        shootAfterSeconds = 0.1f;

        if (currentAngle >= 360f) {
            currentAngle = 0f;
        }

        float newDirectionX = Mathf.Cos(Mathf.PI * 2 * currentAngle / 360);
        float newDirectionY = Mathf.Sin(Mathf.PI * 2 * currentAngle / 360);
        
        GameObject bullet = Instantiate(bulletPrefabs[0], firePoint.position, firePoint.rotation);

        bullet.GetComponent<EnemyBullet>().direction = new Vector2(newDirectionX, newDirectionY).normalized;

        Vector3 rotationVector = Vector3.forward * currentAngle + Vector3.forward * 90;
        bullet.transform.Rotate(rotationVector);

        currentAngle += 20f;
    }

    void ShootSpiralReverse() {
        shootAfterSeconds = 0.1f;

        if (currentAngleR >= 360f) {
            currentAngleR = 0f;
        }

        float newDirectionX = Mathf.Cos(Mathf.PI * 2 * currentAngleR / 360);
        float newDirectionY = Mathf.Sin(Mathf.PI * 2 * currentAngleR / 360);
        
        GameObject bullet = Instantiate(bulletPrefabs[0], firePoint.position, firePoint.rotation);

        bullet.GetComponent<EnemyBullet>().direction = new Vector2(newDirectionX, newDirectionY).normalized;

        Vector3 rotationVector = Vector3.forward * currentAngleR + Vector3.forward * 90;
        bullet.transform.Rotate(rotationVector);

        currentAngleR -= 20f;
    }

    public void ShootForward() {
        shootAfterSeconds = 1.5f;
        int randomBulletPrefab = Random.Range(0, bulletPrefabs.Length);

        for (int i = 0; i < Random.Range(3, 5); i++) {
            GameObject bullet = Instantiate(bulletPrefabs[randomBulletPrefab], firePoint.position, firePoint.rotation);

            Vector2 direction = new Vector2(Random.Range(-0.1f, 0.1f), -1f);
            bullet.GetComponent<EnemyBullet>().direction = direction.normalized;
        }
    }
}
