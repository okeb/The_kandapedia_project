import Timeago from 'stimulus-timeago'
import { fr } from 'date-fns/locale'

export default class extends Timeago {
  connect() {
    super.connect()
    console.log("timeago");
  }

  // You can override this getter to change the locale.
  // Don't forget to import it.
  get locale() {
    return fr
  }
}