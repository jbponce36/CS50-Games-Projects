using UnityEngine;
using System.Collections;

public class Player : MonoBehaviour {

	public float speed = 10.0f;
	private Rigidbody2D rb;
	private float vertical, horizontal;
	public ParticleSystem explosion;
	public AudioSource explosionSound;
	public Animator animator;
	public bool isDead = false;
	public float deadAnimationTime;
	public bool isInvincible = false;
	public float invincibleDelay = 3f;

	void Start () {
		rb = GetComponent<Rigidbody2D>();
	}

	void Update () {

		if (isDead) {
			rb.velocity = new Vector2(0f, 0f);
			return;
		}

		animator.SetFloat("Speed", horizontal);

		// vertical axis is either up or down or w and s on the keyboard, among others
		if (Input.GetAxisRaw("Vertical") != 0) {
			vertical = Input.GetAxis("Vertical") * speed;
		} else {
			vertical = 0f;
		}

		// constrain movement within the bounds of the camera
		if (transform.position.y < -4.5f) {
			transform.position = new Vector3(transform.position.x, -4.5f, transform.position.z);
		}
		if (transform.position.y > 4.5f) {
			transform.position = new Vector3(transform.position.x, 4.5f, transform.position.z);
		}

		// horizontal axis is either left or right or a and d on the keyboard, among others
		if (Input.GetAxisRaw("Horizontal") != 0) {
			horizontal = Input.GetAxis("Horizontal") * speed;
		}
		else {
			horizontal = 0f;
		}

		// constrain movement within the bounds of the background
		if (transform.position.x < -2f) {
			transform.position = new Vector3(-2f, transform.position.y, transform.position.z);
		}
		if (transform.position.x > 2f) {
			transform.position = new Vector3(2f, transform.position.y, transform.position.z);
		}

		// set rigidbody's velocity to our input
		rb.velocity = new Vector2(horizontal, vertical);
	}

	public void PickupBulletPowerup() {
		GetComponent<Weapon>().IncrementBulletType();
	}

	public void PickupFollowerPowerup() {
		if (!isDead) {
			GetComponent<FollowerSpawner>().SpawnFollower();
		}
	}

	public IEnumerator MakeInvincible(int blinks) {
		isInvincible = true;

		Color color = GetComponent<SpriteRenderer>().color;

		for (int i = 0; i < blinks; i++) 
		{
			color.a = 0.5f;
			GetComponent<SpriteRenderer>().color = color;

			yield return new WaitForSeconds(invincibleDelay / (blinks * 2));

			color.a = 1f;
			GetComponent<SpriteRenderer>().color = color;

			yield return new WaitForSeconds(invincibleDelay / (blinks * 2));
		}

		isInvincible = false;
	}

	public void Hurt() {
		if (!isInvincible) {
			if (GetComponent<FollowerSpawner>().numberOfFollowers > 0) {
				GetComponent<FollowerSpawner>().LoseFollower();
				StartCoroutine(MakeInvincible(4));
				SoundManager.PlayLoseFollowerSound();
			} else {
				Die();
			}
		}
	}

	public void Die() {
		explosionSound.Play();
		animator.SetTrigger("Dead");
		isDead = true;
		GameMaster.KillPlayer(this);
	}
}
